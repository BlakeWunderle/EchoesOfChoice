using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Meditate : Ability
    {
        public Meditate()
        {
            Name = "Meditate";
            FlavorText = "Center the mind and spirit. Increases magic defense.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = false;
            ManaCost = 3;
        }
    }
}
