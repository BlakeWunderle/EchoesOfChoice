using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    class Sing : Ability
    {
        public Sing()
        {
            Name = "Sing";
            FlavorText = "Vocally amaze your enemies and distract them. Lowers magic Defense.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 3;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 1;
        }
    }
}
