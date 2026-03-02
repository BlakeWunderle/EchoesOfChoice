using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Siren : BaseFighter
    {
        public Siren(int level = 4)
        {
            Level = level;
            Health = Stat(86, 105, 6, 12, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(9, 17, 1, 3, 4);
            PhysicalDefense = Stat(11, 19, 1, 3, 4);
            MagicAttack = Stat(25, 36, 3, 7, 4);
            MagicDefense = Stat(17, 28, 2, 5, 4);
            Speed = Stat(22, 30, 1, 2, 3);
            Abilities = new List<Ability>() { new SirenSong(), new Torrent() };
            CharacterType = "Siren";
            Mana = Stat(19, 33, 2, 5, 3);
            MaxMana = Mana;
            CritChance = 10;
            CritDamage = 1;
            DodgeChance = 20;
        }

        public Siren(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Siren(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 7);
            MagicDefense += random.Next(2, 5);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
