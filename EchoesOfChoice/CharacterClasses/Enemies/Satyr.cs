using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Satyr : BaseFighter
    {
        public Satyr(int level = 4)
        {
            Level = level;
            Health = Stat(75, 97, 5, 10, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(18, 26, 2, 4, 4);
            PhysicalDefense = Stat(10, 18, 1, 3, 4);
            MagicAttack = Stat(9, 16, 1, 3, 4);
            MagicDefense = Stat(10, 17, 1, 3, 4);
            Speed = Stat(18, 26, 2, 4, 4);
            Abilities = new List<Ability>() { new HoofStomp(), new PanPipes() };
            CharacterType = "Satyr";
            Mana = Stat(22, 36, 2, 5, 4);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 1;
            DodgeChance = 2;
        }

        public Satyr(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Satyr(this);
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
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
