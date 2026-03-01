using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Draconian : BaseFighter
    {
        public Draconian(int level = 6)
        {
            Level = level;
            Health = Stat(81, 91, 0, 0, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(29, 33, 0, 0, 6);
            PhysicalDefense = Stat(17, 21, 0, 0, 6);
            MagicAttack = Stat(29, 33, 0, 0, 6);
            MagicDefense = Stat(20, 25, 0, 0, 6);
            Speed = Stat(30, 35, 0, 0, 6);
            Abilities = new List<Ability>() { new Skewer(), new DrakeStrike(), new ScaleGuard() };
            CharacterType = "Draconian";
            Mana = Stat(25, 29, 0, 0, 6);
            MaxMana = Mana;
            CritChance = 20;
            CritDamage = 2;
            DodgeChance = 16;
        }

        public Draconian(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Draconian(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(0, 1);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(0, 1);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 1);
            PhysicalDefense += random.Next(0, 1);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 1);
            Speed += random.Next(0, 1);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
