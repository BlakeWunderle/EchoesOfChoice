using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Siren : BaseFighter
    {
        public Siren(int level = 3)
        {
            Level = level;
            Health = Stat(72, 88, 5, 10, 3);
            MaxHealth = Health;
            PhysicalAttack = Stat(7, 14, 1, 3, 3);
            PhysicalDefense = Stat(9, 16, 1, 3, 3);
            MagicAttack = Stat(21, 30, 3, 6, 3);
            MagicDefense = Stat(14, 23, 2, 5, 3);
            Speed = Stat(15, 22, 2, 4, 3);
            Abilities = new List<Ability>() { new SirenSong(), new Torrent() };
            CharacterType = "Siren";
            Mana = Stat(19, 33, 2, 5, 3);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 2;
        }

        public Siren(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Siren(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(2, 5);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
